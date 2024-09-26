class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https:usage.jdx.dev"
  url "https:github.comjdxusagearchiverefstagsv0.5.0.tar.gz"
  sha256 "d552054c2dc861a90471d546a701db3929092f304b6fd9cc61cf277bc95d2506"
  license "MIT"
  head "https:github.comjdxusage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "714ee1a4c8c321340d6fe12cbffde0c73fa25db97e2b2913dda1f3564adf02b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "214c4a52cb6aebe3c2ec14f1214c80a157163d52ddc5fd8676e4f62e51349ecc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b55ba4a4a84aa133e80048cde9acc70ef3e9f32cf86bd2662eca45c5dd408cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1506ae8fb060e0f2bfeda4b01a198247d0eefddb268086ce21ff7f9f3808581"
    sha256 cellar: :any_skip_relocation, ventura:       "51475b610cdee425294e265f2578aef930abfe391f27828250669420d297408a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6a6d8fc3db4241a9ff305b98ec4c84a5b366b2c0e0ebda328962dad0d4479f4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match "usage-cli", shell_output(bin"usage --version").chomp
    assert_equal "--foo", shell_output(bin"usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end