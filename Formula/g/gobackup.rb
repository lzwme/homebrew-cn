class Gobackup < Formula
  desc "CLI tool for backup your databases, files to cloud storages"
  homepage "https:gobackup.github.io"
  url "https:github.comgobackupgobackuparchiverefstagsv2.7.0.tar.gz"
  sha256 "52c7f04d5c8c099b0f8396cc084af656e024539810652d4f49e40b994f9addb9"
  license "MIT"
  head "https:github.comgobackupgobackup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "099d4f21e89ece87aeaeee31e49129f8bbacd4c78b2a1b650f35077b06f7d3c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58d4a606263fc2d1b0d705231abcd495d636c3fb54d457ebcb9c1ea050e0e1de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53c2745ea0bf9c288367ad676f6c68417392dadef206342466cac226f10ebbd2"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ab6beaad5f9cec8fc47c9e65d1d2d18ca6c4a89675eb5fa8c45ccfe18aad2b9"
    sha256 cellar: :any_skip_relocation, ventura:        "ace53b5e3338cca10451a113f2df4b30ae8d007088925c587f8e3dc5f955461b"
    sha256 cellar: :any_skip_relocation, monterey:       "7204285530ba84a6eb13b3a08673c5e4609693382e1342c869d9d66baf64c835"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c596924b51ff7ff1fe6c3227307b483fe2d6103d78c717d4754b5249b6c231b"
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