# Generated by Django 3.0.7 on 2020-06-09 21:15
from django.contrib.auth.models import Group, Permission
from django.db import migrations


def create_manager_group(apps, schema_editor):
    group: Group = Group.objects.create(
        name='manager'
    )

    permissions = [
        'change_website',
        'view_website',
        'add_page',
        'change_page',
        'delete_page',
        'view_page',
        'view_extractfield',
        'add_queueitem',
        'change_queueitem',
        'delete_queueitem',
        'view_queueitem',
    ]

    for permission in Permission.objects.filter(codename__in=permissions).all():
        group.permissions.add(permission)


class Migration(migrations.Migration):
    dependencies = [
        ('seosnap', '0003_queueitem'),
    ]

    operations = [
        migrations.RunPython(create_manager_group)
    ]
