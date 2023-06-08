class Gobackup < Formula
  desc "CLI tool for backup your databases, files to cloud storages"
  homepage "https://gobackup.github.io"
  url "https://ghproxy.com/https://github.com/gobackup/gobackup/archive/v2.3.1.tar.gz"
  sha256 "510d1a0c9efc1ef7a328de69920c45170d1584e14ffbe3b70f01665a3977152c"
  license "MIT"
  head "https://github.com/gobackup/gobackup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "583d5cc9d61feae88046aa2a76e2ba2d76f95818088337744103080cbe10b578"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "583d5cc9d61feae88046aa2a76e2ba2d76f95818088337744103080cbe10b578"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "583d5cc9d61feae88046aa2a76e2ba2d76f95818088337744103080cbe10b578"
    sha256 cellar: :any_skip_relocation, ventura:        "0cda9df561fc2950c04bc1fdeb012aef28a97cd72c885480577b9e29bc22ccd3"
    sha256 cellar: :any_skip_relocation, monterey:       "0cda9df561fc2950c04bc1fdeb012aef28a97cd72c885480577b9e29bc22ccd3"
    sha256 cellar: :any_skip_relocation, big_sur:        "0cda9df561fc2950c04bc1fdeb012aef28a97cd72c885480577b9e29bc22ccd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0221b2fc22a439163b6f3c228791ae6a3618fafb8ee29bd15d7459f821e10d1c"
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