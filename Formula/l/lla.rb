class Lla < Formula
  desc "High-performance, extensible alternative to ls"
  homepage "https:github.comtriyanoxlla"
  url "https:github.comtriyanoxllaarchiverefstagsv0.3.5.tar.gz"
  sha256 "0e364efbb63d78d64006aa9752767152b1ae7a3bd5d7e080cf2e184b366e4562"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d6840527a20ec0ee7e90090b50917684e2770c4f92a17747e3a063b1f95e1f16"
    sha256 cellar: :any,                 arm64_sonoma:  "2692fb6703181c386a5d75d3847b25e9858693c1ab2d28ef03db9b76968584c3"
    sha256 cellar: :any,                 arm64_ventura: "39210c231ffd65127542ca39435a7f185bd997648b5560da60ca39f9d37cef7a"
    sha256 cellar: :any,                 sonoma:        "50f3c66065eb90998dbe9e546c04d0ae3d7a19610cbc2a3b5529915dd0e0deb5"
    sha256 cellar: :any,                 ventura:       "8467f8d06233b539facf4ddc0584580d65b288474fadf42c88e39fb8f67cc858"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2331800f01e2a9f14f401836ee9bf588b560e4b95486263b27e2c13aaafe460e"
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