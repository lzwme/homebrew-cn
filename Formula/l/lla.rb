class Lla < Formula
  desc "High-performance, extensible alternative to ls"
  homepage "https://github.com/chaqchase/lla"
  url "https://ghfast.top/https://github.com/chaqchase/lla/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "241b89106fe2c659f17aec7abe358d173f631a1963ba517f759bc7219aac0426"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4e90a6cb707d5ddb43e30e7bae7380ebdc0da5f47ad5caeccf4d5893c88c8c4c"
    sha256 cellar: :any, arm64_sequoia: "b5c29d39618ffd9cf452f68bb71632c45667e3c06d201f063fa2bd49bb979953"
    sha256 cellar: :any, arm64_sonoma:  "3cc0235c27ba0d6fdda409733b53cf9ca75b6206770ee4af8ef8f6356e714c0c"
    sha256 cellar: :any, sonoma:        "1401c2ee03f49034939706cff0c071ad73b1b2516240300f2b3c33a5b1b996a9"
    sha256 cellar: :any, arm64_linux:   "a3f72014fc6113e96a1fca573ca23a4837c880406e5d65d421caed6f318168c8"
    sha256 cellar: :any, x86_64_linux:  "a45621c41408c99ce248de09ec3a9d345162f2f271c2aec562fa281e937322b5"
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