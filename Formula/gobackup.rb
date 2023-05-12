class Gobackup < Formula
  desc "CLI tool for backup your databases, files to cloud storages"
  homepage "https://gobackup.github.io"
  url "https://ghproxy.com/https://github.com/gobackup/gobackup/archive/v2.0.5.tar.gz"
  sha256 "92feec2661938a4d34a1a7a53b06b1906120fea55224f7ed4647db9e175ef82a"
  license "MIT"
  head "https://github.com/gobackup/gobackup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f01ca0e1d34f38e51cb2fdc684b0fda6c93edaaa4f66262fc8fbf919cb955ba5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f01ca0e1d34f38e51cb2fdc684b0fda6c93edaaa4f66262fc8fbf919cb955ba5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f01ca0e1d34f38e51cb2fdc684b0fda6c93edaaa4f66262fc8fbf919cb955ba5"
    sha256 cellar: :any_skip_relocation, ventura:        "2a378560e22f8332a90b3da08f6030ebb288cf7d325fac3fcba5d727d3e26c3b"
    sha256 cellar: :any_skip_relocation, monterey:       "2a378560e22f8332a90b3da08f6030ebb288cf7d325fac3fcba5d727d3e26c3b"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a378560e22f8332a90b3da08f6030ebb288cf7d325fac3fcba5d727d3e26c3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15d31d38aa1b5f38dfd49d07237cf63cf42268d5e96cc991f2a62dc9a1d693ec"
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