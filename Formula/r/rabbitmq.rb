class Rabbitmq < Formula
  desc "Messaging broker"
  homepage "https:www.rabbitmq.com"
  url "https:github.comrabbitmqrabbitmq-serverreleasesdownloadv3.12.10rabbitmq-server-generic-unix-3.12.10.tar.xz"
  sha256 "cf79a3ae875f3dea23e865f52dbf205f9a98312e98e0836af41aa422752f8f47"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f483ebdc2731cda6146caad79a9016af3f5f7e0513766150de4cafaaa153e69f"
  end

  depends_on "erlang"

  uses_from_macos "python" => :build

  def install
    # Install the base files
    prefix.install Dir["*"]

    # Setup the lib files
    (var"librabbitmq").mkpath
    (var"lograbbitmq").mkpath

    # Correct SYS_PREFIX for things like rabbitmq-plugins
    erlang = Formula["erlang"]
    inreplace sbin"rabbitmq-defaults" do |s|
      s.gsub! "SYS_PREFIX=${RABBITMQ_HOME}", "SYS_PREFIX=#{HOMEBREW_PREFIX}"
      s.gsub! "CLEAN_BOOT_FILE=start_clean", "CLEAN_BOOT_FILE=#{erlang.opt_lib"erlangbinstart_clean"}"
      s.gsub! "SASL_BOOT_FILE=start_sasl", "SASL_BOOT_FILE=#{erlang.opt_lib"erlangbinstart_clean"}"
    end

    # Set RABBITMQ_HOME in rabbitmq-env
    inreplace sbin"rabbitmq-env",
              'RABBITMQ_HOME="$(rmq_realpath "${RABBITMQ_SCRIPTS_DIR}..")"',
              "RABBITMQ_HOME=#{prefix}"

    # Create the rabbitmq-env.conf file
    rabbitmq_env_conf = etc"rabbitmqrabbitmq-env.conf"
    rabbitmq_env_conf.write rabbitmq_env unless rabbitmq_env_conf.exist?

    # Enable plugins - management web UI; STOMP, MQTT, AMQP 1.0 protocols
    enabled_plugins_path = etc"rabbitmqenabled_plugins"
    unless enabled_plugins_path.exist?
      enabled_plugins_path.write "[rabbitmq_management,rabbitmq_stomp,rabbitmq_amqp1_0," \
                                 "rabbitmq_mqtt,rabbitmq_stream]."
    end

    sbin.install prefix"pluginsrabbitmq_management-#{version}privwwwclirabbitmqadmin"
    (sbin"rabbitmqadmin").chmod 0755
    generate_completions_from_executable(sbin"rabbitmqadmin", "--bash-completion", shells: [:bash],
                                         base_name: "rabbitmqadmin", shell_parameter_format: :none)
  end

  def caveats
    <<~EOS
      Management Plugin enabled by default at http:localhost:15672
    EOS
  end

  def rabbitmq_env
    <<~EOS
      CONFIG_FILE=#{etc}rabbitmqrabbitmq
      NODE_IP_ADDRESS=127.0.0.1
      NODENAME=rabbit@localhost
      RABBITMQ_LOG_BASE=#{var}lograbbitmq
      PLUGINS_DIR="#{opt_prefix}plugins:#{HOMEBREW_PREFIX}sharerabbitmqplugins"
    EOS
  end

  service do
    run opt_sbin"rabbitmq-server"
    log_path var"lograbbitmqstd_out.log"
    error_log_path var"lograbbitmqstd_error.log"
    # need erl in PATH
    environment_variables PATH:          "#{HOMEBREW_PREFIX}sbin:usrsbin:usrbin:bin:#{HOMEBREW_PREFIX}bin",
                          CONF_ENV_FILE: etc"rabbitmqrabbitmq-env.conf"
  end

  test do
    ENV["RABBITMQ_MNESIA_BASE"] = testpath"varlibrabbitmqmnesia"
    pid = fork { exec sbin"rabbitmq-server" }
    system sbin"rabbitmq-diagnostics", "wait", "--pid", pid
    system sbin"rabbitmqctl", "status"
    system sbin"rabbitmqctl", "stop"
  end
end