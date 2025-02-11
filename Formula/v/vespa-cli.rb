class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.476.30.tar.gz"
  sha256 "3dc451d01416df7fb4f41992995589892e940ce92b92fe22a99f62e78f9621c5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e28fc8d7f325a80fae83f64fdf19b2676413b9b26af3be825fb38d33d9e331e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e457c978b26979df0056c0e6dc92368d0c7403feca49eced390a26760727e0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d62a78ab59e4da51364b6541c1f3049c8b0a501b81d4726bc71b4dbb405a3ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed6b9983267512b7db203f7e6de1fc6d2597318ccb45d292361161421bfd31ad"
    sha256 cellar: :any_skip_relocation, ventura:       "36d0c6bd113d0aedb81b7d85c918aa34079297ff1a7ae2657eb4e57097c8e4d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1647bf4ac6248f6213d4ba8b1e19cb38461eeb51bf1b544805465732077bbc6f"
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