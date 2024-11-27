class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.447.14.tar.gz"
  sha256 "7937be80fec88a7b48c8a688b9883e1bbb65f270725b5837c8a34124126c9ad2"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9950c00698c7b3d56f5376015b03194b542a66783929c6be1e3e6ca4eef3dc0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48242662342b5a6fb9b12cdce8e9951c2bb8b1794328c2ad9e4caca5ba50de8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b51cd20b50c60424cab985b85a03a6c78c185492ac1709f6db012678d1a9611"
    sha256 cellar: :any_skip_relocation, sonoma:        "6649c9e863d35f270a710db85d2f12f9af0597f26886bf0ca83c07f30980a49b"
    sha256 cellar: :any_skip_relocation, ventura:       "4dafe9d57c25f112ee47804d9be3d744530c37bd07659869037705cdb07dd474"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee1b50059d32354f20ba3ee6c6acbdcd20b3a663bf7f73a6da687e24da5eb8fa"
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
    system bin"vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}vespa config get target")
  end
end