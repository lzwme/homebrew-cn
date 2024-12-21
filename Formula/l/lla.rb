class Lla < Formula
  desc "High-performance, extensible alternative to ls"
  homepage "https:github.comtriyanoxlla"
  url "https:github.comtriyanoxllaarchiverefstagsv0.3.7.tar.gz"
  sha256 "639d4ffe2d3b4e9f77356d2f97a8b0b660efd4a24784b8471a114f9ba6aee6df"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "00daa9e0b01be4ea5b6bbca0fc773a2a324b3265a7db260b11cb62f0d98398b8"
    sha256 cellar: :any,                 arm64_sonoma:  "fda3d3c2a7096101e07ae089943113223370d6b090c2986e29e416b3c342d5ed"
    sha256 cellar: :any,                 arm64_ventura: "acea877b66dcb0f9f8b8473b2b4587a677af46cfb7512927a3cacb0dee9a4ba7"
    sha256 cellar: :any,                 sonoma:        "97d7c15cc291cb002dbfd6f2c4629655224f05728020d248e722edfe58f69524"
    sha256 cellar: :any,                 ventura:       "d0143407e3bd330920f47c1c6d276b0f4ea6a3cfc49b0ae76b8fcd3c2d8a2585"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b2902a02fb232be246d4e1fb315b5ac1891e5f6293f07cb5ce37dcfe0e4f6f4"
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