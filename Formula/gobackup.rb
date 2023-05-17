class Gobackup < Formula
  desc "CLI tool for backup your databases, files to cloud storages"
  homepage "https://gobackup.github.io"
  url "https://ghproxy.com/https://github.com/gobackup/gobackup/archive/v2.1.0.tar.gz"
  sha256 "9e0a72b140a4d9337ed8671a1cd009eefa8fb51b4b1633e26c189fd0af9df919"
  license "MIT"
  head "https://github.com/gobackup/gobackup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8df8f4dc8decd57de23c9001618c249dee14c87dfff53686dd9ff7b2f084919"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8df8f4dc8decd57de23c9001618c249dee14c87dfff53686dd9ff7b2f084919"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8df8f4dc8decd57de23c9001618c249dee14c87dfff53686dd9ff7b2f084919"
    sha256 cellar: :any_skip_relocation, ventura:        "2b5215a4e5e9bd79bf8110e8520ea739cc9eac28e169969766e6ee81b1fa2714"
    sha256 cellar: :any_skip_relocation, monterey:       "2b5215a4e5e9bd79bf8110e8520ea739cc9eac28e169969766e6ee81b1fa2714"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b5215a4e5e9bd79bf8110e8520ea739cc9eac28e169969766e6ee81b1fa2714"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73f52c811c653a01c38143df9518af10899731264cad8a82a598fdd4e5d47313"
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