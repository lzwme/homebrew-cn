class FabricCompletion < Formula
  desc "Bash completion for Fabric"
  homepage "https:github.comn0740fabric-completion"
  url "https:github.comn0740fabric-completion.git",
      revision: "5b5910492046e6335af0e88550176d2583d9a510"
  version "1"
  license "MIT"
  head "https:github.comn0740fabric-completion.git", branch: "master"

  livecheck do
    skip "No version information available to check"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "c79615acadeb92fbdcad5c5b496b9ea36ec2ceedacc17fd26807d6c2c8fb1477"
  end

  def install
    bash_completion.install "fabric-completion.bash" => "fabric"
  end

  def caveats
    <<~EOS
      All available tasks are cached in special file to speed up the response.
      Therefore, Add .fab_tasks~ to your ".gitignore".

      For more details and configuration refer to the home page.
    EOS
  end

  test do
    assert_match "-F __fab_completion",
      shell_output("bash -c 'source #{bash_completion}fabric && complete -p fab'")
  end
end