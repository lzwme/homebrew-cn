class GitMob < Formula
  desc "CLI tool for including co-authors in commits"
  homepage "https:github.comrkotzegit-mobblobmasterpackagesgit-mob"
  url "https:registry.npmjs.orggit-mob-git-mob-4.0.0.tgz"
  sha256 "eab3ac78b6a2eb910cc6d5d3829713ff75bd3df0c26d0339a549d3d88620def6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01a58f261435d930f61c7445d7913c56dda3681608edbb59043b4a0f47ab1e94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01a58f261435d930f61c7445d7913c56dda3681608edbb59043b4a0f47ab1e94"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "01a58f261435d930f61c7445d7913c56dda3681608edbb59043b4a0f47ab1e94"
    sha256 cellar: :any_skip_relocation, sonoma:        "65c238da45f6d94c3352c1cc37bdcb924330a56dfc451c115c66c558d9979baa"
    sha256 cellar: :any_skip_relocation, ventura:       "65c238da45f6d94c3352c1cc37bdcb924330a56dfc451c115c66c558d9979baa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01a58f261435d930f61c7445d7913c56dda3681608edbb59043b4a0f47ab1e94"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system "git", "init", "--initial-branch=main"
    system "git", "config", "--global", "user.name", "Jane Doe"
    system "git", "config", "--global", "user.email", "jane@example.com"

    coauthors_init = {
      "coauthors" => {
        "ad" => { "name" => "Amy Doe", "email" => "amy@findmypast.com" },
        "bd" => { "name" => "Bob Doe", "email" => "bob@findmypast.com" },
      },
    }
    (testpath".git-coauthors").write JSON.pretty_generate(coauthors_init)

    system bin"git-add-coauthor", "bb", "Barry Butterworth", "barry@butterworth.org"
    assert_equal 3, JSON.parse((testpath".git-coauthors").read)["coauthors"].size

    system "git", "config", "--global", "git-mob-config.github-fetch", "true"
    system bin"git-mob", "BrewTestBot"
    assert_equal 4, JSON.parse((testpath".git-coauthors").read)["coauthors"].size

    system bin"git-mob", "bb"

    script = testpath".githooksprepare-commit-msg"
    script.write <<~NODEJS
      #!usrbinenv node
      import { exec } from 'node:child_process';
      import { readFileSync, writeFileSync } from 'node:fs';

      const commitMessage = process.argv[2];
      if (COMMIT_EDITMSGg.test(commitMessage)) {
        exec('git mob-print', function (err, stdout) {
          if (err || !stdout.trim().length) process.exit(0);
          const contents = readFileSync(commitMessage);
          const commentPos = contents.indexOf('# ');
          writeFileSync(commitMessage, contents.slice(0, commentPos) + stdout + contents.slice(commentPos));
        });
      }
    NODEJS
    chmod "+x", script

    system "git", "commit", "--allow-empty", '--message="initial commit"', "--quiet"
    assert_match "Co-authored-by: Barry Butterworth <barry@butterworth.org>",
                 shell_output('git log -1 --pretty=format:"%b"').strip
  end
end