class SoftServe < Formula
  desc "Mighty, self-hostable Git server for the command-line"
  homepage "https:github.comcharmbraceletsoft-serve"
  url "https:github.comcharmbraceletsoft-servearchiverefstagsv0.8.2.tar.gz"
  sha256 "2a55fcc97ee3a67714b7b22f2a56be3835e65bd8bd477c311af331dacc807032"
  license "MIT"
  head "https:github.comcharmbraceletsoft-serve.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85bc09fd28e5c098ab0990635acdd54b69852b952542d4fef2d3613fdf5ded86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85bc09fd28e5c098ab0990635acdd54b69852b952542d4fef2d3613fdf5ded86"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "85bc09fd28e5c098ab0990635acdd54b69852b952542d4fef2d3613fdf5ded86"
    sha256 cellar: :any_skip_relocation, sonoma:        "48decefca6c0282b3a1c48b74aa616198ebd5ac9aca9ea8308d0190639e33e68"
    sha256 cellar: :any_skip_relocation, ventura:       "48decefca6c0282b3a1c48b74aa616198ebd5ac9aca9ea8308d0190639e33e68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e34f3cf4b7d5921712f10a2582325d513587d94ff70786d1b5ec72904cc35402"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.CommitSHA=#{tap.user} -X main.CommitDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:, output: bin"soft"), ".cmdsoft"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}soft --version")

    pid = spawn bin"soft", "serve"
    sleep 1
    Process.kill("TERM", pid)
    assert_path_exists testpath"datasoft-serve.db"
    assert_path_exists testpath"datahooksupdate.sample"
  end
end