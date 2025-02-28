class RakeCompletion < Formula
  desc "Bash completion for Rake"
  homepage "https:github.commernencompletion-ruby"
  url "https:github.commernencompletion-rubyarchiverefstagsv1.0.3.tar.gz"
  sha256 "cbcd002bba2a43730cff54f5386565917913d9dec16dcd89345fbe298fe4316b"
  license "MIT"
  head "https:github.commernencompletion-ruby.git", branch: "main"

  livecheck do
    formula "ruby-completion"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5004cd20889962fc9ce3a921f56e27cb5a28e0f88fde57ae1428e28e0dbf89bb"
  end

  def install
    bash_completion.install "completion-rake" => "rake"
  end

  test do
    assert_match "-F __rake",
      shell_output("bash -c 'source #{bash_completion}rake && complete -p rake'")
  end
end