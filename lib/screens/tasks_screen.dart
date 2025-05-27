import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import 'task_edit_screen.dart';

class TasksScreen extends StatefulWidget { //TasksScreen kế thừa từ StatefulWidget, nghĩa là màn hình này có trạng thái có thể thay đổi trong quá trình sử dụng
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();  //Nó trả về một đối tượng của lớp _TasksScreenState, nơi bạn sẽ viết toàn bộ logic và UI động của màn hình. Hàm này băys buộc khi extends StatefulWidget
 // _TasksScreenState sẽ chứa toàn bộ giao diện và xử lý tương tác.
}

class _TasksScreenState extends State<TasksScreen> {
  String _selectedFilter = 'All';     //Mặc định là 'All', nghĩa là ban đầu không áp dụng bộ lọc gì (hiển thị tất cả nhiệm vụ).
  String _selectedSort = 'Due Date';  //Mặc định là 'Due Date' – nghĩa là danh sách sẽ được sắp xếp theo ngày đến hạn.

  @override
  //Đây là hàm build trong một widget Flutter có chức năng hiển thị danh sách công việc (tasks), cho phép lọc và sắp xếp, đồng thời có nút để thêm công việc mới. 

  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    List<Task> filteredTasks = _filterTasks(taskProvider.tasks);
    filteredTasks = _sortTasks(filteredTasks);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                _selectedFilter = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'All', child: Text('All Tasks')),
              const PopupMenuItem(value: 'Pending', child: Text('Pending')),
              const PopupMenuItem(value: 'Completed', child: Text('Completed')),
              const PopupMenuItem(value: 'Work', child: Text('Work')),
              const PopupMenuItem(value: 'Personal', child: Text('Personal')),
              const PopupMenuItem(value: 'Shopping', child: Text('Shopping')),
            ],
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) {
              setState(() {
                _selectedSort = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Due Date', child: Text('Due Date')),
              const PopupMenuItem(value: 'Priority', child: Text('Priority')),
              const PopupMenuItem(value: 'Title', child: Text('Title')),
              const PopupMenuItem(value: 'Created', child: Text('Created Date')),
            ],
          ),
        ],
      ),
      body: taskProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : filteredTasks.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.task_alt,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No tasks found',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add a new task to get started',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    return EnhancedTaskItem(task: filteredTasks[index]);
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TaskEditScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Task'),
      ),
    );
  }

  List<Task> _filterTasks(List<Task> tasks) {
    switch (_selectedFilter) {
      case 'Pending':
        return tasks.where((task) => !task.isCompleted).toList();
      case 'Completed':
        return tasks.where((task) => task.isCompleted).toList();
      case 'Work':
        return tasks.where((task) => task.category == 'Work').toList();
      case 'Personal':
        return tasks.where((task) => task.category == 'Personal').toList();
      case 'Shopping':
        return tasks.where((task) => task.category == 'Shopping').toList();
      default:
        return tasks;
    }
  }

  List<Task> _sortTasks(List<Task> tasks) {
    switch (_selectedSort) {
      case 'Due Date':
        tasks.sort((a, b) {
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return a.dueDate!.compareTo(b.dueDate!);
        });
        break;
      case 'Priority':
        tasks.sort((a, b) => b.priority.compareTo(a.priority));
        break;
      case 'Title':
        tasks.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Created':
        tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
    }
    return tasks;
  }
}

class EnhancedTaskItem extends StatelessWidget {
  final Task task;
  
  const EnhancedTaskItem({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    
    return Dismissible(
      key: Key(task.id),
      background: _buildDismissibleBackground(),
      confirmDismiss: (direction) => _showDeleteConfirmation(context),
      onDismissed: (direction) {
        taskProvider.deleteTask(task.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Task "${task.title}" deleted'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                taskProvider.addTask(task);
              },
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskEditScreen(task: task),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildStatusSection(taskProvider),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _buildPriorityIndicator(),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              task.title,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                decoration: task.isCompleted 
                                    ? TextDecoration.lineThrough 
                                    : null,
                                color: task.isCompleted 
                                    ? Colors.grey 
                                    : Theme.of(context).textTheme.titleMedium?.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (task.description?.isNotEmpty ?? false)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            task.description!,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (task.dueDate != null) ...[
                            Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              '${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: _getCategoryColor(task.category).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: _getCategoryColor(task.category).withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              task.category,
                              style: TextStyle(
                                fontSize: 12,
                                color: _getCategoryColor(task.category),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.red[300]),
                  onPressed: () => _showDeleteConfirmation(context).then((confirm) {
                    if (confirm ?? false) {
                      taskProvider.deleteTask(task.id);
                    }
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDismissibleBackground() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.red[100],
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      child: const Icon(Icons.delete, color: Colors.red),
    );
  }

  Widget _buildStatusSection(TaskProvider taskProvider) {
    return Column(
      children: [
        Transform.scale(
          scale: 1.3,
          child: Checkbox(
            value: task.isCompleted,
            onChanged: (value) {
              taskProvider.updateTask(task.copyWith(isCompleted: value));
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            side: BorderSide(
              color: task.isCompleted ? Colors.green : Colors.grey,
              width: 1.5,
            ),
            fillColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (states.contains(MaterialState.selected)) {
                return Colors.green;
              }
              return Colors.transparent;
            }),
          ),
        ),
        Text(
          task.isCompleted ? 'Done' : 'Todo',
          style: TextStyle(
            fontSize: 12,
            color: task.isCompleted ? Colors.green : Colors.orange,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityIndicator() {
    Color priorityColor;
    String priorityText;
    
    switch (task.priority) {
      case 2:
        priorityColor = Colors.red;
        priorityText = 'High';
        break;
      case 1:
        priorityColor = Colors.orange;
        priorityText = 'Medium';
        break;
      default:
        priorityColor = Colors.green;
        priorityText = 'Low';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: priorityColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: priorityColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        priorityText,
        style: TextStyle(
          fontSize: 12,
          color: priorityColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Work':
        return Colors.blue;
      case 'Personal':
        return Colors.purple;
      case 'Shopping':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) { //Hàm _showDeleteConfirmation bạn đưa ra có chức năng hiển thị hộp thoại xác nhận xóa công việc (Task) trong Flutter.
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}