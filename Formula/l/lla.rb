class Lla < Formula
  desc "High-performance, extensible alternative to ls"
  homepage "https:github.comtriyanoxlla"
  url "https:github.comtriyanoxllaarchiverefstagsv0.3.6.tar.gz"
  sha256 "adb4e36e7eb94d537fb218a78474dc61d8fe5384f5130bbafffc3fabdd68d1fd"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e58f8b5f53f4e074912fdc2a58051a8f5a0b11d7eb3b9558f03fc33fcfa7fa83"
    sha256 cellar: :any,                 arm64_sonoma:  "d232fe876f89ff1d1166a7e6e81215b13cc9325f483ca816b5d2a217132963a8"
    sha256 cellar: :any,                 arm64_ventura: "140e7cb12381c1b1f11ac3fed21a1d35ef608c23417210af9696772a5cb7032d"
    sha256 cellar: :any,                 sonoma:        "a9a53e6c7636dd3498fd49ee246cc85873cc4442e1820212ed7dea9a41f4007e"
    sha256 cellar: :any,                 ventura:       "c98e823c2cef35d3416351037e5b854f159c9743f9af28f42806a61e88a73a2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75c52e5b9594a5e49b77e492370db519211832f1254675ea45a022b324d47d24"
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