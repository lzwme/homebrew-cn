class Yarn < Formula
  desc "JavaScript package manager"
  homepage "https://yarnpkg.com/"
  url "https://yarnpkg.com/downloads/1.22.22/yarn-v1.22.22.tar.gz"
  sha256 "88268464199d1611fcf73ce9c0a6c4d44c7d5363682720d8506f6508addf36a0"
  license "BSD-2-Clause"

  livecheck do
    skip("1.x line is frozen and features/bugfixes only happen on 2.x")
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9a80ed679d05f019e217f737a7d531f4578144b65be6a1a19d3322ef41d25683"
  end

  depends_on "node" => :test

  conflicts_with "hadoop", because: "both install `yarn` binaries"
  conflicts_with "corepack", because: "both install `yarn` and `yarnpkg` binaries"

  def install
    libexec.install buildpath.glob("*")
    (bin/"yarn").write_env_script libexec/"bin/yarn.js", PREFIX: HOMEBREW_PREFIX
    (bin/"yarnpkg").write_env_script libexec/"bin/yarn.js", PREFIX: HOMEBREW_PREFIX
    inreplace libexec/"lib/cli.js", "/usr/local", HOMEBREW_PREFIX
    inreplace libexec/"package.json", '"installationMethod": "tar"',
                                      "\"installationMethod\": \"#{tap.user.downcase}\""
  end

  def caveats
    <<~EOS
      yarn requires a Node installation to function. You can install one with:
        brew install node
    EOS
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"yarn", "add", "jquery"
    # macOS specific package
    system bin/"yarn", "add", "fsevents", "--build-from-source=true" if OS.mac?
  end
end