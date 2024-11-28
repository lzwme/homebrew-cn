class Lla < Formula
  desc "High-performance, extensible alternative to ls"
  homepage "https:github.comtriyanoxlla"
  url "https:github.comtriyanoxllaarchiverefstagsv0.2.7.tar.gz"
  sha256 "a09d352aa519a0c8e73fc812abd844ca1948b16b73071a68dbd44695fa804c12"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c55294aa140b5e5643251a774189dcfb15549d903c8d22f87f98d721972e8862"
    sha256 cellar: :any,                 arm64_sonoma:  "de3015b2a489de168bfb217f66c16475e9e6d92e093cfce85647402735074412"
    sha256 cellar: :any,                 arm64_ventura: "cd36dbbe69774f47e159abd6968d38e801f3831f433735761115e502f8966a5f"
    sha256 cellar: :any,                 sonoma:        "a9e89bfb960e8cfc1f393f1c3614f28ced5ef58db5a249f129c9f7aed28a0733"
    sha256 cellar: :any,                 ventura:       "38d95db1e5156465318dcabac345bf3f956f61d5fb9554a9e5b405f1a3d4c9fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab53dced7964bcf2f33d9e8202c8926f827a9fa24216365b922b798c9e09014a"
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
      lib.install plugin"targetrelease"shared_library("lib#{plugin.basename}")
    end
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
    inreplace(test_config, ^plugins_dir = ".*"$, "plugins_dir = \"#{opt_lib}\"")

    system bin"lla", "--enable-plugin", "git_status", "categorizer"
    system bin"lla"

    assert_match "lla #{version}", shell_output("#{bin}lla --version")
  end
end