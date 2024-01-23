class Gobackup < Formula
  desc "CLI tool for backup your databases, files to cloud storages"
  homepage "https:gobackup.github.io"
  url "https:github.comgobackupgobackuparchiverefstagsv2.9.0.tar.gz"
  sha256 "e9b30ff9a163bb6c42bc155bc3c34017254aa500bacaa9fac3bb2833a1c00b3f"
  license "MIT"
  head "https:github.comgobackupgobackup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e2a0de6464e33dd524d5b7dbddecabf7e4b89e03413516d8ebb33131762fe1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f33d4154fc6b3d1a57a1bc9f404b59d92df9dcd039471bd0e797e8fd290b37f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a52afd724f7a5386d6bd72bb83b012d28531af34a8ff014bb08295aecb0abedb"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e3dfe596c40f6c66c1115b012895d311f4be4fe90dd517288009f3552314724"
    sha256 cellar: :any_skip_relocation, ventura:        "d9b994ee881bc6750cdda8adf7a9c385e7263121d24da4a49f227d8d9fa86052"
    sha256 cellar: :any_skip_relocation, monterey:       "b5c92b064d9cfa416d534ade4278fabcdf0e18824491cf13681edfd8d2aa2ddd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06ddf5d444ecd7720b8ba4fd8a983f09d82f6186f8dfea38fec68b714e37f798"
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
    assert_match version.to_s, shell_output("#{bin}gobackup -v")

    config_file = testpath"gobackup.yml"

    config_file.write <<~EOS
      models:
        test:
          storages:
            local:
              type: local
              path: #{testpath}backups
          archive:
            includes:
              - #{config_file}
    EOS

    out = shell_output("#{bin}gobackup perform -c #{config_file}").chomp
    assert_match "succeeded", out
    tar_files = Dir.glob("#{testpath}backups*.tar")
    assert_equal 1, tar_files.length
  end
end