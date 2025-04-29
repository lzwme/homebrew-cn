class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.512.63.tar.gz"
  sha256 "634a421b8c47ff752be29ece5b8b185e6abad487eb7927eaeae061bb902ed445"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51e62ae5fe625bcab23026ea7662b3a98842a89d86733d072c6c60f8c7911298"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "159f3d877e71078bdb0d87b1630c30dac378013be2f7eba22fd5bb86271902b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d1393e3a4b460014198d044cd18abf37da57a9e68253d3bbd363a225ef80abd4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8e1fe5a895c9b92c453eec054be00ea926f7639d7c96e73f7428b8272e08f06"
    sha256 cellar: :any_skip_relocation, ventura:       "9c4ce51ff369a0804f4a7402a12545440acc9638bfa3c8eb37776516d8861c08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75362c046edcc9f4c2a73d4223be002d6916d07caa185f3b4f3e4bfb5f2234d8"
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