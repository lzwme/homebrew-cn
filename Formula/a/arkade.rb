class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.87.tar.gz"
  sha256 "1167620bc0f44db500f1f39eab6aff05b88271dbd3e239a0b06fb58cefa53dc7"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19b047baebffa2954021dd6dc7a56130f8adb1563f211ae4288546f1c8f44827"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19b047baebffa2954021dd6dc7a56130f8adb1563f211ae4288546f1c8f44827"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19b047baebffa2954021dd6dc7a56130f8adb1563f211ae4288546f1c8f44827"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ac552f7e895c1823daa4a89fdfc5f71f61a7924c5a99448c52b59db0eac62d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8a822d8340f7bcd4dd272223543e93bd1e819820d391013aca5968bf68eb236"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1f70fe7ed29d99cd1f47ccf1707256b6a4d9bdcc1c08f32392f8b6215bf7052"
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