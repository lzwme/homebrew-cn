class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghproxy.com/https://github.com/vespa-engine/vespa/archive/v8.221.29.tar.gz"
  sha256 "84293ed8fdc04a59e20f9f2440989a4ffe5e1fa0c00fd385dd7e50ab828d2c91"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24d3153a074c93dab36d926a23e9d2bde0f84e308d36bd166d0c19bfc96fc461"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19c77760b7dcb9bd7efd4db478286648bc514c4db9cdb8353337da1f7f48f3e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2fe4351edd3105fd09a18c15e8f251f91c6ba59d53ae769f74d6ee17e726df2a"
    sha256 cellar: :any_skip_relocation, ventura:        "893f458dc69877ecd452cd50da9a1d5497e652fd3b0e6c2229913f6f43470e47"
    sha256 cellar: :any_skip_relocation, monterey:       "aa7bbc581e4841400d5e40fdcc76ca4f9299cc24c5dc478097ff5b584c7cbd7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "8299bae227a39b49e29ea24fde1f7a17112134f8300e1e8b9d6a6c2ca8e6f203"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7a5a31562c75f34a62ff61ae43af73cc73bbbae945f30a042c9dc3fd3061803"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "install", "manpages"
      end
      generate_completions_from_executable(bin/"vespa", "completion")
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    output = shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    assert_match "Error: deployment not converged", output
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end