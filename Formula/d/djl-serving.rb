class DjlServing < Formula
  desc "This module contains an universal model serving implementation"
  homepage "https:github.comdeepjavalibrarydjl-serving"
  url "https:publish.djl.aidjl-servingserving-0.31.0.tar"
  sha256 "c56c91063d822f00e1d9d6cc6049e9d55a5f2e586920a5b29e4c1e6ab8b28daa"
  license "Apache-2.0"

  # `djl-serving` versions aren't considered released until a corresponding
  # release is created in the main `deepjavalibrarydjl` repository.
  livecheck do
    url "https:github.comdeepjavalibrarydjl"
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fee22666bf7fe1ea8043c52c077dbaf8c9514c86bcd435ae30c3d35199289090"
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