class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.494.23.tar.gz"
  sha256 "62cd6700f3ece345ac4867ad91e794fbfc33d6d0c1778c8d7934e788199f4703"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59bdde299ea633defd2d848743aa098890e8b19db07ab6d331d3a747d1c32a15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1bf833acfb6cbbdcdba5f995592b0f61921f0011c7d82ebb49c6c6cf4c80f2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8821cc49268289b38036c8a8a351b57b17c314a1ddfb603090b90529fc37495e"
    sha256 cellar: :any_skip_relocation, sonoma:        "546ff42f2df3ede11107d6bb206bd9d42460ee02cb3b26c968be345052d472b0"
    sha256 cellar: :any_skip_relocation, ventura:       "1be596f788dbc80a6e7a071b37dcdc2db368193680eb0e5a0777fcf014a7e498"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fc9bb1fd06a8a42f44174d36740e1cf7cdf53d45f62b1d996688b3c5bbcb59d"
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