class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/x-motemen/ghq"
  url "https://github.com/x-motemen/ghq.git",
      tag:      "v1.9.2",
      revision: "deaa4ad5f047de79d14cdf696066cc44d4da5dba"
  license "MIT"
  head "https://github.com/x-motemen/ghq.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b14a44162f0831a85b39ff398c2e2c52f83a718f7549aff4bac1ae974f9a57ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc136bf938c9e020cf81157f87ac5d5e8c48894df9ef8c897989bb84acbcfc7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b80fb9ca9d07d9ecb4a111d0d64dd5578dcf9352979372c847f1e1694f8e355"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ec189cbed0824f35d29b8d32836abc98cff02eb57630e76320d27ec2740d177"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba0bcaa8d76bdf5a9ab2ad4986ab773f2176e52a0ff549a7961df2b71c579b18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52dd69f3968793ee7f0f8380c4260c48ede78ffac5795ead5034b2eb4df4143a"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERBOSE=1"
    bin.install "ghq"
    bash_completion.install "misc/bash/_ghq" => "ghq"
    zsh_completion.install "misc/zsh/_ghq"
    fish_completion.install "misc/fish/ghq.fish"
  end

  test do
    assert_match "#{testpath}/ghq", shell_output("#{bin}/ghq root")
  end
end