class Lla < Formula
  desc "High-performance, extensible alternative to ls"
  homepage "https://github.com/chaqchase/lla"
  url "https://ghfast.top/https://github.com/chaqchase/lla/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "46fc2806209ea005408646869834d34ca7b065bac59cfa8e0a9d89ba8f83abfc"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "984815f7598a90e89e6faae44b2c9f2cf34f329bd162a85e5e88350693dedc98"
    sha256 cellar: :any, arm64_sequoia: "9d72b76f1fcd8d9726202c8e502dac05b3ce5a8d08f2dabee698b1ba5939f7cf"
    sha256 cellar: :any, arm64_sonoma:  "435cb336fe9a111b72cc16bce5e4f95fca70ed493552bb356e9f5e7ff991faea"
    sha256 cellar: :any, sonoma:        "49eb84ec07688145a4ac09c70a5e522e6ae59797a0aa6eed5541fa273ab75400"
    sha256 cellar: :any, arm64_linux:   "f4b71414d1114f16a6b531f3b74c795f65c409f60fbe81d2543deaf877340e53"
    sha256 cellar: :any, x86_64_linux:  "f269272be74311f9b0048b8e25fdd74c23755f88d3e19eb737a8b7eaa0df89ed"
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