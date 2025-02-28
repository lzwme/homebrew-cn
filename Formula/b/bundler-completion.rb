class BundlerCompletion < Formula
  desc "Bash completion for Bundler"
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
    sha256 cellar: :any_skip_relocation, all: "eba47de2a5fee4ae57cc2e1eec146d6b8602819de68ab8865a092cfbfe8aa2e8"
  end

  def install
    bash_completion.install "completion-bundle" => "bundler"
  end

  test do
    assert_match "-F __bundle",
      shell_output("bash -c 'source #{bash_completion}bundler && complete -p bundle'")
  end
end