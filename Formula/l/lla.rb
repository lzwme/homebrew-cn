class Lla < Formula
  desc "High-performance, extensible alternative to ls"
  homepage "https://github.com/chaqchase/lla"
  url "https://ghfast.top/https://github.com/chaqchase/lla/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "cd357b38c609cde98ccbf31bcca86052443d8678d800eb7c06701e3900d8a6cf"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f843bad9fb234786832e9dd176bdc49be26e4636d26cda61407c09401f3c3159"
    sha256 cellar: :any,                 arm64_sonoma:  "d095080f516e4b4a05121baf1fa975cb90b7458745f90cb15203e43900d0764a"
    sha256 cellar: :any,                 arm64_ventura: "b55189ff73b42247f8d36037baff7f2504e5c6e7806690a3d7baf880ead018f1"
    sha256 cellar: :any,                 sonoma:        "0b3255c01979fe70603c5d4ffd6024002e92e307c13e435e47f7509438d3358c"
    sha256 cellar: :any,                 ventura:       "4bbf9a1a0d13033cf08b7090a3fd53509513ca0f2f1ec0c6ca03c5fc44d0929c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36810faf318538e370ff78210517638d871de8a85489b1fce5de80101cdb44b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29024f27cb53a2e8d6844885ad69b7f6d6666024877dfaa4b23fb568a0e6ebc8"
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