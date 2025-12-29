class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghfast.top/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.620.35.tar.gz"
  sha256 "303cb826483c4f228e44b088d2ae265f13ff4c1604689d585611a4a36250cffa"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f5ad6a15c2c74155bbd9ed90649dd4c4023d9aebd620c591ed84ea6ce301d44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edf372b1ac8c316116cb0d90239c93ebe16d5afb35810447830a1fdc59da5f11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07546f62aef7f885387a2c266ac51989ee610157b1467cad5128f4752957de83"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d6eb4b2bac7359892c15012ee3ea016337319c8f7c0f09b262f009f50b346c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd2f13b767198615d7b820019fce671bc9757292081a9b1c210be5a8393fccc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34b9e8971371cc6e69c14afb58bc7b281110f8ec84ef1f265a9f873ba241013c"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "install", "manpages"
      end
      generate_completions_from_executable(bin/"vespa", shell_parameter_format: :cobra)
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    output = shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    assert_match "Error: deployment not converged", output
    system bin/"vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end