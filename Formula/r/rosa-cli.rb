class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https:www.openshift.comproductsamazon-openshift"
  url "https:github.comopenshiftrosaarchiverefstagsv1.2.48.tar.gz"
  sha256 "52d2b8f96b6959ba12cb07b23459cd421430a648061f25d913d32fc8cc97522b"
  license "Apache-2.0"
  head "https:github.comopenshiftrosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26c4d486500c51ca64ab4844b32021b8b0d7520df71c3836d661924ca041df35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a103c226683582550af73cb544b984ef2fc7930d293c12c0d5aba00202cf17cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "49fc01980a430cb1b264f8997e34cd7f2aa9aaf1f611d0f36b561027334d59e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "f51eed6adbe7bc60c515249f65b41b19eb636d1ff48c95845e03a9af0de4b8a9"
    sha256 cellar: :any_skip_relocation, ventura:       "0c1ef388c7be771756aedc28038a1477c8ba184e3e4707ad5c8a9420b4f4f109"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "155dfb8c1903e21ebca06a398a54f4e4c596d11204e96695810408817b1ed982"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin"rosa"), ".cmdrosa"

    generate_completions_from_executable(bin"rosa", "completion", base_name: "rosa")
  end

  test do
    output = shell_output("#{bin}rosa create cluster 2<&1", 1)
    assert_match "Failed to create OCM connection: Not logged in", output

    assert_match version.to_s, shell_output("#{bin}rosa version")
  end
end