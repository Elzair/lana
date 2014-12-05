#!/bin/sh

# Process input arguments
INIT=''
USAGE="Usage: $0 [-h] [--init[=]<upstart|systemd>]" 
optspec=":h-:"
while getopts "$optspec" optchar
do
    case "${optchar}" in
        -)
            case "${OPTARG}" in
                init=*)
                    INIT=${OPTARG#*=}
                    case "${INIT}" in
                        upstart)
                            ;;
                        systemd)
                            ;;
                        *)
                            echo "Unknown init: ${INIT}" >&2
                            echo "$USAGE" >&2
                            exit 1
                            ;;
                    esac
                    ;;
                *)
                    echo "Unknown option --${OPTARG}" >&2
                    echo "$USAGE" >&2
                    exit 2
                    ;;
            esac
            ;;
        h)
            echo "$USAGE"
            exit 0 
            ;;
        *)
            echo "Unknown argument: '-${OPTARG}'" >&2
            echo "$USAGE" >&2
            exit 3
            ;;
    esac
done


# Add user
useradd -m -s /bin/false -d /home/lana lana

# Give user non-sudo access to docker
gpasswd -a lana docker
service docker restart

# Create repos & logs directories
sudo -u lana mkdir /home/lana/repos
sudo -u lana mkdir /home/lana/logs
sudo -u lana mkdir /home/lana/local-images

# Add SSH Keys
sudo -u lana ssh-keygen -t rsa -C "lana@example.com"
sudo -u lana cat /home/lana/.ssh/id_rsa.pub
echo "Add the previous line to the list of SSH keys for your git host account."

# Give lana ownership of /usr/local/lib/node_modules/lana 
chown -R lana:lana /usr/local/lib/node_modules/lana
