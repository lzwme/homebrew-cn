class Lla < Formula
  desc "High-performance, extensible alternative to ls"
  homepage "https:github.comtriyanoxlla"
  url "https:github.comtriyanoxllaarchiverefstagsv0.2.9.tar.gz"
  sha256 "e21cba33f4f2da83c4a58d799b5b36cca0bce1946231e611cceacf681584a67a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e3ae1d1272bf0986f14b3b0e3b59eca7ebd29d41c83bac402c946a708709429a"
    sha256 cellar: :any,                 arm64_sonoma:  "c9bdd32ccd66cc3169d8097580545ff3d398a3204ca9feb0746b88510a76f743"
    sha256 cellar: :any,                 arm64_ventura: "46bea68ecfeebac773b8299fe44b7da3e063490886ff96b7c14f6972efcdcd63"
    sha256 cellar: :any,                 sonoma:        "469bc5757d83a6eb98ec7cb69f49f69b60cee95c1569adf9f204334fd58beb3b"
    sha256 cellar: :any,                 ventura:       "28b96efbf8dddb237e90f40a042c004a0679ee71a6c224478fddcc8284fa5c32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53b347ae2ff74facbeda40012390f7b36f4fb3600c9098d21f424f2cd961aa24"
  end

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