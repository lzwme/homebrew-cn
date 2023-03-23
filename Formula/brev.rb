class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://ghproxy.com/https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.213.tar.gz"
  sha256 "85580e96b44f32f9ceef3610f71b6274da008dea822dde8bf119bb9364b442c8"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71ebabe9ca0f2a261a4e26c91790a2bbbbbb58844fb39f30a57aca0791ee38e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0ac53e255d0709141fce8f2ec720468e3c4d733ea1b7b61d2f88f67010bdfb9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f27a892ed33bcc7b8112ab66ca4b338c1d481244b3b0610a1ae7c3371d1b0a5"
    sha256 cellar: :any_skip_relocation, ventura:        "481f78dac07aa1f0f1dc87c03b736693afa9993f2f2da2a5a398694fcc13d702"
    sha256 cellar: :any_skip_relocation, monterey:       "671e96f8614a492ecb4daac099d7e87f46111d58288d63b30035fc899df8780c"
    sha256 cellar: :any_skip_relocation, big_sur:        "08e0c4c7eb7a6189521784d23b16dbd2867736743b389b0675ccd904100fe99c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e893871c9a96f94e7636de85ca3dd79cbe643693e5b5a8648b4d88be34119385"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end