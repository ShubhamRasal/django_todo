from django.test import TestCase, Client
from django.urls import reverse
from todo.models import Todo
import datetime
# Create your tests here.

client = Client()

class CreateTodoTest(TestCase):
    """ Test module for Create Todo API """
    def setUp(self):
      self.obj1 = Todo.objects.create(
            title = "Todo 1",
            body  = "Todo1 body",
            is_completed = False,
            date_created = datetime.date.today()
      )
  
    def test_todo_creation(self):
      response = client.get(
            reverse('todo_list'))
      self.assertEqual(len(response._container), 1)