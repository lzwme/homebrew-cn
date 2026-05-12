class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.95.tar.gz"
  sha256 "2d3ffc8b727016bdfd4aafa792f9ff79594dd4494fa6c52ae7c007763e692b2d"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "012be2bcfcfa7640177bf3163be2d65df50a83c750dccbeb34264668a60eb7ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "012be2bcfcfa7640177bf3163be2d65df50a83c750dccbeb34264668a60eb7ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "012be2bcfcfa7640177bf3163be2d65df50a83c750dccbeb34264668a60eb7ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "875f76a0319d3c790ba04256f3e5fd57f25518b8d0ab3aff38b56b27e694b063"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54c28b69b9bcacae420a6167ca8b9ddf72200d18b5df45d1fdd340139e2f275f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8488258f8620e7a329f675124cf230e17f09e79495f79f55fc9518d242798061"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/arkade/pkg.Version=#{version}
      -X github.com/alexellis/arkade/pkg.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    bin.install_symlink "arkade" => "ark"

    generate_completions_from_executable(bin/"arkade", shell_parameter_format: :cobra)
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion/"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match "Version: #{version}", shell_output("#{bin}/arkade version")
    assert_match "Info for app: openfaas", shell_output("#{bin}/arkade info openfaas")
  end
end