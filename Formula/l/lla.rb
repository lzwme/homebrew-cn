class Lla < Formula
  desc "High-performance, extensible alternative to ls"
  homepage "https:github.comtriyanoxlla"
  url "https:github.comtriyanoxllaarchiverefstagsv0.3.4.tar.gz"
  sha256 "25c3b2fb886510e91ee227bfbb93d7f91c2dda829b4e2edde394c1ebd02b711c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "35e750424c83b088a5a9f6c062488d3d92099418fabd00d8381946c6f910e780"
    sha256 cellar: :any,                 arm64_sonoma:  "09a7aa50cdb9e61cd40f6f1a2cb407b737b84503bac043253dc81110313d3e52"
    sha256 cellar: :any,                 arm64_ventura: "4cfb22375595c926e29875e43ce63958f474eb528293d7fe1dae9c38b3e0bf6a"
    sha256 cellar: :any,                 sonoma:        "1937d537abb7e62c81d0cb889277bf279a02864c4407b8afa27885cffdc12244"
    sha256 cellar: :any,                 ventura:       "d481e5bbe1a0f3458356cb5c7b3f21d81455885a1d29c232a704421d2e46f8c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69a175007018dd1457a8382e5689a1f8cdb258ca36d3ec2da7dd51ac5bd8e341"
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