class Lla < Formula
  desc "High-performance, extensible alternative to ls"
  homepage "https://github.com/chaqchase/lla"
  url "https://ghfast.top/https://github.com/chaqchase/lla/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "a11ba912b4fdca16d5c9b0624c2a08c52de7de3048e2a225c4a6a9d2013e4fe5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2fe113981df0c4dcb3ab12c0026d9dc603f4d21a6c8347d321fa54ad806fc7db"
    sha256 cellar: :any,                 arm64_sequoia: "cd17d35d100cb44319488b64d79cecf8c67118d46fa37454e3d6f673676c4f5d"
    sha256 cellar: :any,                 arm64_sonoma:  "212d496f353f4505b799ae43b6f476fb375b74423566c5cfbb3a9f0ae63cdcff"
    sha256 cellar: :any,                 sonoma:        "8751919ce8ba5b287eaa7301c8cf3ba0de8fbf7928250c38517260e54290fa31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d89f703cf3ee497403ed25d93a0b6774c7670b25defed2bc072a8785496c71a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55019b657fc61b5cebbe8b1de770866a6201bd3cd44fab08a63d6e04bb3ffc01"
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

    system bin/"lla", "init"

    output = shell_output("#{bin}/lla config")
    assert_match "Current configuration at \"#{test_config}\"", output

    system bin/"lla"

    # test lla plugins
    system bin/"lla", "config", "--set", "plugins_dir", opt_lib

    system bin/"lla", "--enable-plugin", "git_status", "categorizer"
    system bin/"lla"

    assert_match "lla #{version}", shell_output("#{bin}/lla --version")
  end
end