class Lla < Formula
  desc "High-performance, extensible alternative to ls"
  homepage "https://github.com/chaqchase/lla"
  url "https://ghfast.top/https://github.com/chaqchase/lla/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "c8cafb2eb4145b9655335a6574f296a122b3410c1e36debc6450fee3f4ec0b63"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3bc4465cdfb353ac1eee66c68a22668f131759f48918a61225049dd10239a60b"
    sha256 cellar: :any,                 arm64_sequoia: "acbd90d2d8929474d6ca77f0f85fe756f799d79de22c9409d789513fbdeb2628"
    sha256 cellar: :any,                 arm64_sonoma:  "c613efc2200979938e38c43bf4a7ac9794c37a3c18244707b34114fae099c09a"
    sha256 cellar: :any,                 sonoma:        "0b2469d3837ca20414ff961cabcdee9bb49429c3eda498c0407b7446e7a1fa22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "727f25a03314b01b28353625ed314ba0675cf0474e093dbdbaa597c1bfd3074f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4541fb6ddcc92a8c423e989405bf9c88bc99bafcfcc22881c60e35ecf5118c87"
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