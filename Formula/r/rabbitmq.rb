class Rabbitmq < Formula
  desc "Messaging and streaming broker"
  homepage "https:www.rabbitmq.com"
  url "https:github.comrabbitmqrabbitmq-serverreleasesdownloadv4.0.4rabbitmq-server-generic-unix-4.0.4.tar.xz"
  sha256 "b024b75935bc9b30597b3ea5c5d3846b8a8f887e0f1d5703f00974ea481342f3"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "25ecb2a43134c5f1968c6f35dbb83f9b259f26096271202bfb21bc82fc9a6a3d"
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

    rabbitmqadmin = prefix.glob("pluginsrabbitmq_management-*privwwwclirabbitmqadmin")
    if (rabbitmqadmin_count = rabbitmqadmin.count) > 1
      odie "Expected only one `rabbitmqadmin`, got #{rabbitmqadmin_count}"
    end

    sbin.install rabbitmqadmin
    (sbin"rabbitmqadmin").chmod 0755
    generate_completions_from_executable(sbin"rabbitmqadmin", "--bash-completion", shells: [:bash],
                                         base_name: "rabbitmqadmin", shell_parameter_format: :none)
  end

  def caveats
    <<~EOS
      Management UI: http:localhost:15672
      Homebrew-specific docs: https:rabbitmq.cominstall-homebrew.html
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