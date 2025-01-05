class Lla < Formula
  desc "High-performance, extensible alternative to ls"
  homepage "https:github.comtriyanoxlla"
  url "https:github.comtriyanoxllaarchiverefstagsv0.3.9.tar.gz"
  sha256 "7a6ad5be16258087d03bb357a9eb9e77b59a70803c7cf2eba037b1b8dae01986"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "874a9397ed50ab637cff1bb56fe0f06d1f9c2733730c147b7851dff285ea9744"
    sha256 cellar: :any,                 arm64_sonoma:  "e14f8a592a2cad9e030d29dcada7d9fa70e1c11d989dd8102f04c8106bf0ce47"
    sha256 cellar: :any,                 arm64_ventura: "fd96b2722a0d1c400ab3c2c2e1dddbc930b3af852269c5e937334c75d8f4d4dc"
    sha256 cellar: :any,                 sonoma:        "d40754a05d98af22dd5cadf135b9c81ce89ca445cf23e0761287909dad9ba974"
    sha256 cellar: :any,                 ventura:       "2eeb7b1777e290ba62d556744e56b24387b285e849def383c95b332bf9d327d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "726b0477e7a4b0d0ba33baea9020deddfa6745348626b02639c584a7271708c5"
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