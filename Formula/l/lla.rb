class Lla < Formula
  desc "High-performance, extensible alternative to ls"
  homepage "https://github.com/chaqchase/lla"
  url "https://ghfast.top/https://github.com/chaqchase/lla/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "187b26dfd3e03f09f8cdbdf53035e8184f3fa48fbe3e2c694070744ff6e38724"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "40955b9e3266e83e449c97965746dd2c302dc2bd6abe0694b5cb426414ea3432"
    sha256 cellar: :any, arm64_sequoia: "49ebd573bc5fda1c5cb360e25a7ac601e648411ab16852eddcd7de26f53ee689"
    sha256 cellar: :any, arm64_sonoma:  "89fd23bae9db8dc9012aad90da85a0107e98596df070296e994d2f0832fd84e3"
    sha256 cellar: :any, sonoma:        "a4a43764ef1a06d98dd7e968b2274184ce3b956b26355fb7fbe97dd077964d94"
    sha256 cellar: :any, arm64_linux:   "1e55e5d59ecd0af10dbc6c0e6ece128e6d81fedfa434160cc072387eae6e57d5"
    sha256 cellar: :any, x86_64_linux:  "597ec131c1a9efa01aa9cbda7afa76239e01b79cd21f63b5c9106d4fcafc6738"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "lla")

    (buildpath/"plugins").each_child do |plugin|
      next unless plugin.directory?

      plugin_path = plugin/"Cargo.toml"
      next unless plugin_path.exist?

      system "cargo", "build", "--jobs", ENV.make_jobs.to_s,
                               "--locked", "--lib", "--release",
                               "--manifest-path=#{plugin_path}"
    end
    lib.install Dir["target/release/*.{dylib,so}"]
  end

  def caveats
    <<~EOS
      The Lla plugins have been installed in the following directory:
        #{opt_lib}
    EOS
  end

  test do
    test_config = testpath/".config/lla/config.toml"

    system bin/"lla", "init", "--default"

    output = shell_output("#{bin}/lla config")
    assert_match "Config file: #{test_config}", output

    system bin/"lla"

    # test lla plugins
    system bin/"lla", "config", "--set", "plugins_dir", opt_lib

    system bin/"lla", "--enable-plugin", "git_status", "categorizer"
    system bin/"lla"

    assert_match "lla #{version}", shell_output("#{bin}/lla --version")
  end
end