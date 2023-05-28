class Gobackup < Formula
  desc "CLI tool for backup your databases, files to cloud storages"
  homepage "https://gobackup.github.io"
  url "https://ghproxy.com/https://github.com/gobackup/gobackup/archive/v2.2.0.tar.gz"
  sha256 "276a3685d91918e92eaa032a7e41980638210635a929ffa23573011ac27ff65b"
  license "MIT"
  head "https://github.com/gobackup/gobackup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7b130ed00e804a20fe1f92c2f4b5f66e134390979bfe711e6cb3346dd88fd61"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7b130ed00e804a20fe1f92c2f4b5f66e134390979bfe711e6cb3346dd88fd61"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7b130ed00e804a20fe1f92c2f4b5f66e134390979bfe711e6cb3346dd88fd61"
    sha256 cellar: :any_skip_relocation, ventura:        "4139b0b4f1c8f874a25efa892d7cf96337c65d4ebc06925f0463fd2fa6e30faf"
    sha256 cellar: :any_skip_relocation, monterey:       "4139b0b4f1c8f874a25efa892d7cf96337c65d4ebc06925f0463fd2fa6e30faf"
    sha256 cellar: :any_skip_relocation, big_sur:        "4139b0b4f1c8f874a25efa892d7cf96337c65d4ebc06925f0463fd2fa6e30faf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e04601ea1952abb7487ff966b202fe6df155784feea236af21b3cab0680695b1"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    revision = build.head? ? version.commit : version

    chdir "web" do
      system "yarn", "install"
      system "yarn", "build"
    end
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{revision}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gobackup -v")

    config_file = testpath/"gobackup.yml"

    config_file.write <<~EOS
      models:
        test:
          storages:
            local:
              type: local
              path: #{testpath}/backups
          archive:
            includes:
              - #{config_file}
    EOS

    out = shell_output("#{bin}/gobackup perform -c #{config_file}").chomp
    assert_match "succeeded", out
    tar_files = Dir.glob("#{testpath}/backups/*.tar")
    assert_equal 1, tar_files.length
  end
end