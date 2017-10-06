#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>

MODULE_LICENSE("GPL");

static int __init hello_init(void)
{
    printk(KERN_INFO "Hello Atomic!\n");
    return 0;
}

static void __exit hello_cleanup(void)
{
    printk(KERN_INFO "Good bye Atomic.\n");
}

module_init(hello_init);
module_exit(hello_cleanup);

