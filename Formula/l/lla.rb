class Lla < Formula
  desc "High-performance, extensible alternative to ls"
  homepage "https:github.comtriyanoxlla"
  url "https:github.comtriyanoxllaarchiverefstagsv0.3.8.tar.gz"
  sha256 "5c8ec7700f5ddd3d207be766384aa192a27dc3302ead7549128470d667d2f404"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f6a91c23ea68f16dc00c96ced65d6160a25c48481b9a2a1fd46f99a3e35a2e5d"
    sha256 cellar: :any,                 arm64_sonoma:  "0d47695fa5b57bb0b027a0e8428a216ef549ea73b10dee393f608356895e4f63"
    sha256 cellar: :any,                 arm64_ventura: "108e48bb348b584763694593d7a8fb287fb5e039a702f6de4d61d2929ec7aca7"
    sha256 cellar: :any,                 sonoma:        "c5f9fa33f5b86f32fe2326a2023611a94e20eff50e5a89a722b4e3424e6c570b"
    sha256 cellar: :any,                 ventura:       "e5d5cfb549141b24dc664b46444dcb5f5835e71fe0e680707a80f13acbc8b6da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "137b69af954f46cb8e6610560f230e573537351d654a6aa5c371a2354e3e8040"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "lla")

    (buildpath"plugins").each_child do |plugin|
      next unless plugin.directory?

      plugin_path = plugin"Cargo.toml"
      next unless plugin_path.exist?

      system "cargo", "build", "--jobs", ENV.make_jobs.to_s,
                               "--locked", "--lib", "--release",
                               "--manifest-path=#{plugin_path}"
    end
    lib.install Dir["targetrelease*.{dylib,so}"]
  end

  def caveats
    <<~EOS
      The Lla plugins have been installed in the following directory:
        #{opt_lib}
    EOS
  end

  test do
    test_config = testpath".configllaconfig.toml"

    system bin"lla", "init"

    output = shell_output("#{bin}lla config")
    assert_match "Current configuration at \"#{test_config}\"", output

    system bin"lla"

    # test lla plugins
    system bin"lla", "config", "--set", "plugins_dir", opt_lib

    system bin"lla", "--enable-plugin", "git_status", "categorizer"
    system bin"lla"

    assert_match "lla #{version}", shell_output("#{bin}lla --version")
  end
end