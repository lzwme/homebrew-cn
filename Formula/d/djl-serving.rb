class DjlServing < Formula
  desc "This module contains an universal model serving implementation"
  homepage "https:github.comdeepjavalibrarydjl-serving"
  url "https:publish.djl.aidjl-servingserving-0.33.0.tar"
  sha256 "48326bdeacba973ac54d8f07e22b6be0a0edafe2e1377d7031665d5efe726691"
  license "Apache-2.0"

  # `djl-serving` versions aren't considered released until a corresponding
  # release is created in the main `deepjavalibrarydjl` repository.
  livecheck do
    url "https:github.comdeepjavalibrarydjl"
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9d0f31ed27572681ddd8cc68ecb6396fd1697ad89cd56bec21fa22f8f3017a38"
  end

  depends_on "openjdk"

  def install
    # Install files
    rm_r(Dir["bin*.bat"])
    mv "binserving", "bindjl-serving"
    libexec.install Dir["*"]
    env = { MODEL_SERVER_HOME: "${MODEL_SERVER_HOME:-#{var}}" }
    env.merge!(Language::Java.overridable_java_home_env)
    (bin"djl-serving").write_env_script "#{libexec}bindjl-serving", env
  end

  service do
    run [opt_bin"djl-serving", "run"]
    keep_alive true
  end

  test do
    port = free_port
    (testpath"config.properties").write <<~EOS
      inference_address=http:127.0.0.1:#{port}
      management_address=http:127.0.0.1:#{port}
    EOS
    ENV["MODEL_SERVER_HOME"] = testpath
    cp_r Dir["#{libexec}*"], testpath
    fork do
      exec bin"djl-serving -f config.properties"
    end
    sleep 30
    cmd = "http:127.0.0.1:#{port}ping"
    assert_match "{}\n", shell_output("curl --fail #{cmd}")
  end
end