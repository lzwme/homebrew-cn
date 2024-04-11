class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.328.24.tar.gz"
  sha256 "08659f672255b37dc84e8c91209c0b219270b40cad5a3538f74cbe95f21c5052"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "88bc58db9f642c7da9c00ab2d26c874d69ea61b303c31a487dd7d977d68bc783"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ddb20239b737df9ca12c14688840285d58d4adc25b25b1e0ed3fa63e83d7641c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08832a7f49afd3da122e37e3feb185c2f6a5208d2e3b9d56d01cf8d833918198"
    sha256 cellar: :any_skip_relocation, sonoma:         "083b7c18e1b525483e2020933caad94f97dae118cace100c02a53e95a3b2251b"
    sha256 cellar: :any_skip_relocation, ventura:        "9b1a1c47319d9c7fb8c7ca2b73eb8a82eeceb9c9cbd7a026ec5bd10bc849d16f"
    sha256 cellar: :any_skip_relocation, monterey:       "9e9dce7a74ed3241a6db89b72dd3b3d2195047fd3a5d0f2dcfd8935bac189ddc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2979f7ae0dd98b0d89a40afaf637d88fd27b1b7ef52e31fd5169148de5f1d653"
  end

  depends_on "go" => :build

  def install
    cd "clientgo" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "install", "manpages"
      end
      generate_completions_from_executable(bin"vespa", "completion")
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    output = shell_output("#{bin}vespa document get #{doc_id} 2>&1", 1)
    assert_match "Error: deployment not converged", output
    system "#{bin}vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}vespa config get target")
  end
end