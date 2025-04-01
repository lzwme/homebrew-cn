class Treefmt < Formula
  desc "One CLI to format the code tree"
  homepage "https:treefmt.comlatest"
  url "https:github.comnumtidetreefmtarchiverefstagsv2.2.0.tar.gz"
  sha256 "9ddb3eb4a03c7d273754dc250f485be8e23b7ef94446576d7e97aaa79e0c1463"
  license "MIT"
  head "https:github.comnumtidetreefmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c5b33a12374894c8fe5539427d9755b4931905c40269662a2d43642ee44357c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c5b33a12374894c8fe5539427d9755b4931905c40269662a2d43642ee44357c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2c5b33a12374894c8fe5539427d9755b4931905c40269662a2d43642ee44357c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b416d2eb308654959d1d29946e5e3b17c42b0f4ead996647e821d1139677c67a"
    sha256 cellar: :any_skip_relocation, ventura:       "b416d2eb308654959d1d29946e5e3b17c42b0f4ead996647e821d1139677c67a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38925e5133b3c1068feb91978225726a2f434c8f944d48fae0977fc57ca7d8e0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comnumtidetreefmtv2build.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}treefmt 2>&1", 1)
    assert_match "failed to find treefmt config file: could not find [treefmt.toml .treefmt.toml]", output
    assert_match version.to_s, shell_output("#{bin}treefmt --version")
  end
end