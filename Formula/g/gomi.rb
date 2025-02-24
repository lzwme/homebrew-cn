class Gomi < Formula
  desc "Functions like rm but with the ability to restore files"
  homepage "https:gomi.dev"
  url "https:github.combabarotgomiarchiverefstagsv1.5.1.tar.gz"
  sha256 "f4da25f59f230d20249adb00f3cf60ebac49c0e9c4293952c46a6329542f2c97"
  license "MIT"
  head "https:github.combabarotgomi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a8c9fdf102bd889f9d9c34ffb6933ec2cd5371cb7607db534fe8e883ae98292"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a8c9fdf102bd889f9d9c34ffb6933ec2cd5371cb7607db534fe8e883ae98292"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a8c9fdf102bd889f9d9c34ffb6933ec2cd5371cb7607db534fe8e883ae98292"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba88c3d98011ae04ce73a4ba048d68fa5490bc15e68817effca81a84cea6dcf2"
    sha256 cellar: :any_skip_relocation, ventura:       "ba88c3d98011ae04ce73a4ba048d68fa5490bc15e68817effca81a84cea6dcf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "426d7265ca3c87c49d0f4e6e6e7b4ba27beff420927d07c656d80dd877df0645"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=v#{version}
      -X main.revision=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    # Create a trash directory
    mkdir ".gomi"

    assert_match version.to_s, shell_output("#{bin}gomi --version")

    (testpath"trash").write <<~TEXT
      Homebrew
    TEXT

    # Restoring is done in an interactive prompt, so we only test deletion.
    assert_path_exists testpath"trash"
    system bin"gomi", "trash"
    refute_path_exists testpath"trash"
  end
end