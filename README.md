# dotfiles
![Ubuntu latest](https://github.com/davidmogar/dotfiles/workflows/Ubuntu%20latest/badge.svg) ![Ubuntu latest](https://github.com/davidmogar/dotfiles/workflows/Ubuntu%20LTS/badge.svg)

This Ansible playbook installs and maintain all the packages and dotfiles I use in my development environment. It is based on roles and prepared to work over a fresh Ubuntu installation.

## Usage

The following command is all you need to have it ready to roll:

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/davidmogar/dotfiles/master/bootstrap.sh)"
```

And in case of using wget:

```sh
sh -c "$(wget -O- https://raw.githubusercontent.com/davidmogar/dotfiles/master/bootstrap.sh)"
```

### Applying a specific profile and/or tag

A specific profile can be applied by setting the `PROFILE` variable before the bootstraping commands. The definition of these profiles can be found in the `host_vars` directory. The following example shows how to use this variable:

```sh
PROFILE=profile sh -c "$(curl -fsSL https://raw.githubusercontent.com/davidmogar/dotfiles/master/bootstrap.sh)"
```

It is also possible to run only specifc parts by using the `--tags` options. For example, the following command will only run the bootstrap tasks, which will prepare the repositories and install some required packages:

```sh
PROFILE=profile TAGS=bootstrap sh -c "$(curl -fsSL https://raw.githubusercontent.com/davidmogar/dotfiles/master/bootstrap.sh)"
```

### Running the playbook manually

Once the system has been bootstrapped, a copy of the repository will be placed in `${HOME}/.ansible/dotfiles`. To run manually from that repository, execute the following commands:

```sh
cd ~/.ansible/dotfiles
git pull origin master
ansible-playbook -i inventory playbook.yml --diff [--limit PROFILE] [--tags TAGS] --ask-become-pass
```

Note that both, limit and tags, are optional arguments.

## Roles

<table>
  <thead>
    <tr>
      <th align="left" width="200">Name</th>
      <th align="left">Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><a href="roles/apt-meta">apt-meta</a></td>
      <td>Manages APT packages.</td>
    </tr>
    <tr>
      <td><a href="roles/apt-repo-meta">apt-repo-meta</a></td>
      <td>Manages APT repositories.</td>
    </tr>
  </tbody>
</table>

## License

This project is under the GNU General Public License v3.0. Check [LICENSE](https://github.com/davidmogar/dotfiles/blob/master/LICENSE) file to see the full text full text.
