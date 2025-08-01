cask "dwarf-fortress" do
  version "0.47.05"
  sha256 "bc79a92adb96497d59546378e8c9ab2ef67ca22abfbd9763616de9c2e00e5f24"

  url "https://www.bay12games.com/dwarves/df_#{version.minor}_#{version.patch}_osx.tar.bz2"
  name "Dwarf Fortress"
  desc "Single-player fantasy game"
  homepage "https://www.bay12games.com/dwarves/"

  no_autobump! because: :requires_manual_review

  # shim script (https://github.com/Homebrew/homebrew-cask/issues/18809)
  shimscript = "#{staged_path}/df_osx/df.wrapper.sh"
  disable! date: "2024-12-16", because: :discontinued

  binary shimscript, target: "dwarf-fortress"

  preflight do
    File.write shimscript, <<~EOS
      #!/bin/sh
      exec '#{staged_path}/df_osx/df' "$@"
    EOS
  end

  uninstall_preflight do
    if Dir.exist?("#{staged_path}/df_osx/data/save")
      FileUtils.cp_r("#{staged_path}/df_osx/data/save", "/tmp/dwarf-fortress-save/")
    end
  end

  caveats do
    requires_rosetta
    <<~EOS
      During uninstall, your save data will be copied to /tmp/dwarf-fortress-save
    EOS
  end
end