class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https:okteto.com"
  url "https:github.comoktetooktetoarchiverefstags3.8.0.tar.gz"
  sha256 "829a671c01ac735924916e3192591790821d46e4cfa972654859a8eced9de56c"
  license "Apache-2.0"
  head "https:github.comoktetookteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1a64192077e115499fdea005899f2b68ca12da8cce69c6c19accad9562797ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "248487186c5086011cf57deb56e81056114f3093592fc4ddd53713a8364d58df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "513baa1af9db7dd265c2f3127ffd287d87f784b5437375d73243ce4b025fa4b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a579b115cd9accbdc7241fa8ce2d5bb5bdbca7b4690295dc43ef2ddea458f59"
    sha256 cellar: :any_skip_relocation, ventura:       "4d582853ec1d5528c377d30e0bcdc12263baa0a0c0e0ea74cd36a6830fcdd427"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "611fce46dd42d6d79f3cd8dbe576e8151655b6661a038ec94d623a165bdf737c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8399abca8b1e9bb7de3630934cdbc2eaeb9286f5a6e5cbdf6b74bef06756e519"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comoktetooktetopkgconfig.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags:, tags:)

    generate_completions_from_executable(bin"okteto", "completion")
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}okteto version")

    assert_match "Your context is not set", shell_output("#{bin}okteto context list 2>&1", 1)
  end
end