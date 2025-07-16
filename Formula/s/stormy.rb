class Stormy < Formula
  desc "Minimal, customizable and neofetch-like weather CLI based on rainy"
  homepage "https://github.com/ashish0kumar/stormy"
  url "https://ghfast.top/https://github.com/ashish0kumar/stormy/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "f07e4e3055ace0f2fa5db0364dde4aa7829055b8b1890a6871e833c987cc6ceb"
  license "MIT"
  head "https://github.com/ashish0kumar/stormy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3c89bacf10510e274d11adc4c2bc3c7ae4a70fdcf00c505a94a0fd103765561"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3c89bacf10510e274d11adc4c2bc3c7ae4a70fdcf00c505a94a0fd103765561"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d3c89bacf10510e274d11adc4c2bc3c7ae4a70fdcf00c505a94a0fd103765561"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d2eec31312292c3b8323eb8b5bb6f050ba3555be3e4bbcc7661447eaf0773f7"
    sha256 cellar: :any_skip_relocation, ventura:       "1d2eec31312292c3b8323eb8b5bb6f050ba3555be3e4bbcc7661447eaf0773f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c597ee33ae26b1afa966e36c06bc85cc8108bf2f4999e2386d3095757a99b8f1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Weather", shell_output("#{bin}/stormy --city London")
    assert_match "Error: City must be set in the config file or via command line flags",
      shell_output("#{bin}/stormy 2>&1", 1)
  end
end