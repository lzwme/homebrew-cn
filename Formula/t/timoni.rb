class Timoni < Formula
  desc "Package manager for Kubernetes, powered by CUE and inspired by Helm"
  homepage "https:timoni.sh"
  url "https:github.comstefanprodantimoniarchiverefstagsv0.24.0.tar.gz"
  sha256 "8622b7bbecaacc62f1ba44c796188e583fada1537d44e18b52ecdb0c61454e3c"
  license "Apache-2.0"
  head "https:github.comstefanprodantimoni.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9eb8a12c3189a6f1fc1d8f30d5dbbad8cdc33f7379f57550794b64b590a0c371"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a7908c8fb62bf682f84c1552ceddaedad9d22b8f08d1571c1d6ab56d80111b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d542d48ab9c827dd159ba362f874e99d9fc9752e0ab41241531e84249fa9da5"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e23b99bd61bfa5f21561e7ad60981252249cc7494e8403fe966f70f749b39dd"
    sha256 cellar: :any_skip_relocation, ventura:       "8e9d22c3e0dd294d88ac00859370fffe95678d8153224439365e1d13b8c0b83d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9e958819032eef43066ccdf602c58a25b17bcd5240a507f340eca9b395482d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b862eaf34380ef2d39125bb3c1f4598d64ff3920677f3d8e44f59a844e3f0502"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=#{version}"), ".cmdtimoni"

    generate_completions_from_executable(bin"timoni", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}timoni version")

    system bin"timoni", "mod", "init", "test-mod", "--namespace", "test"
    assert_path_exists testpath"test-modtimoni.cue"
    assert_path_exists testpath"test-modvalues.cue"

    output = shell_output("#{bin}timoni mod vet test-mod 2>&1")
    assert_match "INF timoni.shtest-mod valid module", output
  end
end