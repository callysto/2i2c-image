c.ServerProxy.servers = {
     'openrefine': {
         'command': [
             '/bin/bash', '-c',
             '/opt/openrefine/refine -p {port} -i 0.0.0.0',
         ],
         'timeout': 60,
         'launcher_entry': {
             'title': 'OpenRefine',
             'icon_path': '/opt/openrefine/logo.svg',
         },
     }
}
