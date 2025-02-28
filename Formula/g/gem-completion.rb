class GemCompletion < Formula
  desc "Bash completion for gem"
  homepage "https:github.commernencompletion-ruby"
  url "https:github.commernencompletion-rubyarchiverefstagsv1.0.3.tar.gz"
  sha256 "cbcd002bba2a43730cff54f5386565917913d9dec16dcd89345fbe298fe4316b"
  license "MIT"
  version_scheme 1
  head "https:github.commernencompletion-ruby.git", branch: "main"

  livecheck do
    formula "ruby-completion"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ae8a1951beb43f5f63f4a3961545d3a325e8ccdbf9da708c5175673012a5757a"
  end

  def install
    bash_completion.install "completion-gem" => "gem"
  end

  test do
    assert_match "-F __gem",
      shell_output("bash -c 'source #{bash_completion}gem && complete -p gem'")
  end
end