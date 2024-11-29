class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https:github.comschollzcroc"
  url "https:github.comschollzcrocarchiverefstagsv10.1.1.tar.gz"
  sha256 "7351abed3bb509e6c13f1a9d8c38662dcafc29f8b1e123127e8ee75e7eb0719b"
  license "MIT"
  head "https:github.comschollzcroc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17a360ff63213fa051b8fc8774cbdb7be8ae0ef19db5ad03ba4671a17e6f4148"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17a360ff63213fa051b8fc8774cbdb7be8ae0ef19db5ad03ba4671a17e6f4148"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "17a360ff63213fa051b8fc8774cbdb7be8ae0ef19db5ad03ba4671a17e6f4148"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b8f459fdacf8b2d710b8fcccb66c5274965146728f2c75a6e7d51bb1a987a1b"
    sha256 cellar: :any_skip_relocation, ventura:       "1b8f459fdacf8b2d710b8fcccb66c5274965146728f2c75a6e7d51bb1a987a1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3e81ce6772047bf1fda9c749c57d96292b717d83ea4c19e40087021f080d7e1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # As of https:github.comschollzcrocpull701 an alternate method is used to provide the secret code
    ENV["CROC_SECRET"] = "homebrew-test"

    port=free_port

    fork do
      exec bin"croc", "relay", "--ports=#{port}"
    end
    sleep 3

    fork do
      exec bin"croc", "--relay=localhost:#{port}", "send", "--code=homebrew-test", "--text=mytext"
    end
    sleep 3

    assert_match shell_output("#{bin}croc --relay=localhost:#{port} --overwrite --yes homebrew-test").chomp, "mytext"
  end
end